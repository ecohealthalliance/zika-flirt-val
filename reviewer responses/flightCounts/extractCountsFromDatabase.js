ssh -i ~/.ssh/infrastructure.pem ubuntu@flirt-reporting.eha.io
sudo docker exec -ti mongodb /bin/bash
mongo
// I know this is bad form, but here's some shell stuff to get me where I want
// to be.


// Setup.
rs.slaveOk()
use grits-net-meteor
show collections



// This part of the script creates a JSON array with the number of flights
// scheduled on each day.

var startDate = new Date(2016, 0, 1)
// var endDate = new Date(2016, 0, 5)
var endDate = new Date(2016, 5, 30)

// This array maps the output of getDay to Innovata's days. They start
// numbering with 1 on Monday through 7 on Sunday.

function dayMap(date) {
    var days = new Array(7)
    days[0]=  "day7"
    days[1] = "day1"
    days[2] = "day2"
    days[3] = "day3"
    days[4] = "day4"
    days[5] = "day5"
    days[6] = "day6"
    return days[date.getDay()]
}

// We have to construct our query dynamically so that we can iterate over days
// and count the number of flights occurring on each day. These are the
// flights whose start dates are before the current date, whose discontinued
// dates are after the current date, and which occur on that day of the week.
// This will take a while to run.

var query = {}
query["effectiveDate"] = {$lte: startDate}
query["discontinuedDate"] = {$gte: startDate}
query[dayMap(startDate)] = true

var flightCountsByDate = []
var iterDate = startDate
while (iterDate <= endDate) {
    print(iterDate)
    var query = {} // Build our query using the date
    query["effectiveDate"] = {$lte: iterDate}
    query["discontinuedDate"] = {$gte: iterDate}
    query[dayMap(iterDate)] = true
    var CountOfFlightsOnDate = db.legs.find(query).count()
    flightCountsByDate.push({date: iterDate, count: CountOfFlightsOnDate})
    printjson({date: iterDate, count: CountOfFlightsOnDate})
    iterDate.setDate(iterDate.getDate() + 1)
}
// printjson(flightCountsByDate) // Don't use this, because it leaves ISODate unquoted which throws a syntax error.
JSON.stringify(flightCountsByDate, null, 4)
// This bit of code isn't working at the moment. I have to copy and paste what's logged to the console as the loop runs.



// This part of the script outputs a JSON array with flight counts for each
// airport, alongside that airport's country name and global region. I
// aggergate Abe's flightCounts collection looking up the relevant information
// from the airports collection, and then projecting it to be simpler.

flightCountsByAirport = db.airportCounts.aggregate([
    {
        "$lookup": {
            from: "airports",
            localField: "_id",
            foreignField: "_id",
            as: "airportMeta"
        }
    },
    {
        "$project": {
            airportCode: "$_id",
            arrivalCount: 1,
            departureCount: 1,
            totalCount: "$_total",
            countryName: "$airportMeta.countryName",
            globalRegion: "$airportMeta.globalRegion"

        }
    },
    {
        "$unwind": "$countryName"
    },
    {
        "$unwind": "$globalRegion"
    }
]).toArray()
printjson(flightCountsByAirport)

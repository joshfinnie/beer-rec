fs = require "fs"
ElasticSearch = require "elasticsearch"

client = new ElasticSearch.Client(
  host: "localdocker:9200"
  log: "trace"
)

esIndex = 0
directory = __dirname + "/beer_dump"

fs.readdir directory, (err, files) ->
  throw err  if err
  files.forEach (file) ->
    fs.readFile directory + "/" + file, "utf-8", (err, beers) ->
      throw err  if err
      beers = JSON.parse(beers)
      data = beers["data"]
      data.forEach (elem, index, array) ->
        output = {}
        output["brewery"] = elem["breweries"][0]["name"] if elem["breweries"]
        output["beer"] = elem["name"]
        output["glassware"] = elem["glass"]["name"] if elem["glass"]
        output["category"] = elem["style"]["category"]["name"] if elem["style"]
        output["glasswareId"] = elem["glasswareId"] if elem["glasswareId"]
        output["styleId"] = elem["styleId"] if elem["styleId"]
        if output["glasswareId"] and output["styleId"] and output["brewery"]
          esIndex++
          client.create
            index: "beers_test"
            type: "beer_test"
            id: esIndex
            body: output
          , (err, res) ->
            if err
              console.log err
            else
              console.log res

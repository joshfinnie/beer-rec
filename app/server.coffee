Hapi = require "hapi"
Good = require "good"
ElasticSearch = require "elasticsearch"

client = new ElasticSearch.Client({
  host: process.env.ES_PORT_9200_TCP_ADDR + ":" + process.env.ES_PORT_9200_TCP_PORT,
  log: 'trace'
})

port = process.env.PORT or 1337
server = new Hapi.Server(port)

server.route
  method: "GET"
  path: "/"
  handler: (req, res) ->
    res "Hello, ElasticSearch!"

server.route
  method: "GET"
  path: "/search"
  handler: (req, res) ->
    client.search(
      index: 'beers_test'
      type: 'beer_test'
      body:
        query:
          match:
            beer: req.query.beer
    ).then ((resp) ->
        results = []
        hits = resp.hits.hits
        for hit in hits
            results.push(hit['_source'])
        res results
    ), (err) ->
        console.trace err.message
server.route
  method: "GET"
  path: "/recommend"
  handler: (req, res) ->
    client.search(
      index: 'beers_test'
      type: 'beer_test'
      body:
        query:
          match:
            beer: req.query.beer
    ).then ((resp) ->
        hit = resp.hits.hits[0]
        glasswareId = hit['_source']['glasswareId']
        styleId = hit['_source']['styleId']
        client.search(
          index: 'beers_test'
          type: 'beer_test'
          body:
            query:
              bool:
                must: [
                  term:
                    'glasswareId': glasswareId
                  term:
                    'styleId': styleId
                ]
        ).then ((resp) ->
            results = []
            hits = resp.hits.hits
            for hit in hits
                results.push(hit['_source'])
            res results
        ), (err) ->
            console.trace err.message
    ), (err) ->
        console.trace err.message

server.pack.register
  plugin: Good
  options:
    reporters: [
      reporter: require("good-console")
      args: [
        log: "*"
        request: "*"
      ]
    ]
, (err) ->
  throw err  if err
  server.start ->
    server.log "info", "Server running at: http://localhost:" + port


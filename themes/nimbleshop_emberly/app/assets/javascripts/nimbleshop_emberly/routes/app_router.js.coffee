Nimbleshop.Router = Ember.Router.extend

  location: "hash"

  enableLogging: true

  root: Ember.Route.extend

    index: Ember.Route.extend
      route: "/"
      redirectsTo: 'products.index'

Nimbleshop.Router = Ember.Router.extend

  location: "hash"

  enableLogging: true

  root: Ember.Route.extend

    index: Ember.Route.extend
      route: "/"
      redirectsTo: 'products.index'

    products: Ember.Route.extend
      route: "/products"

      index: Ember.Route.extend
        route: '/'
        connectOutlets: (router) ->
          router.get('applicationController').connectOutlet('products', Nimbleshop.Product.find())

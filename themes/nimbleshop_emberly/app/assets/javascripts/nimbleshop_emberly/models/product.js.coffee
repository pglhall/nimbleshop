Nimbleshop.Product = DS.Model.extend
  name: DS.attr('string')
  description: DS.attr('string')
  price: DS.attr('number')
  pictureUrl: DS.attr('string')
  pictures: DS.hasMany('Myshop.Picture' , embedded: true)


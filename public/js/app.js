var Zone = Backbone.Model.extend({});

var ZoneCollection = Backbone.Collection.extend({
  model: Zone,
  url: '/zones',
});


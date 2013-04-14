var yy = {};
(
  yy.model = function() {
    var subscriptions = {};
    return {
      sub: function(evt, action) {
        if(!subscriptions[evt]){
          subscriptions[evt]=[];
        }
        subscriptions[evt].push(action);
      },
      pub: function(evt, message) {
        if (subscriptions[evt]) {
          for(var i=0;i<subscriptions[evt].length;i++){
            subscriptions[evt][i](message);
          }
        }
      }
    };
}());
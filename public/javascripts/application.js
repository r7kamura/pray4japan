var bindRemote = function(selector) {
  $(selector)
    .click(function(){
      $(this).hide();
      $('<img src="/images/loading.gif" class="loading"/>').insertAfter($(this));
    });
  $(selector)
    .bind("ajax:success", function(evt, data, status, xhr){
      $(this)
        .replaceWith(data)
        .fadeIn();
      bindRemote(selector);
      $(".loading").fadeOut();
    });
  $('.images a').lightBox();
};

var setTwitterGadget = function() {
  new TWTR.Widget({
    version: 2,
    type: 'search',
    search: 'prayforjapan',
    interval: 2000,
    title: 'Twitter',
    subject: 'prayforjapan',
    width: 'auto',
    height: '600',
    theme: {
      shell: {
        background: 'white',
        color: '#444444'
      },
      tweets: {
        background: '#ffffff',
        color: '#444444',
        links: '#1985b5'
      }
    },
    features: {
      scrollbar: false,
      loop: true,
      live: true,
      hashtags: true,
      timestamp: true,
      avatars: true,
      toptweets: true,
      behavior: 'default'
    }
  }).render().start();
};

$(function(){
  $('.socialButtons .hatena').socialbutton('hatena');
  $('.socialButtons .twitter').socialbutton('twitter', { button: 'horizontal', lang: 'en', related: 'ruedap' });
  $('.socialButtons .facebook').socialbutton('facebook_like', { button: 'button_count', locale: 'en_US' });
  $('.images a').lightBox();
  bindRemote('.moreButton');
});

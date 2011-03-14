// selectorの位置までscroll
var bindSmoothScroll = function(selector) {
  $(selector).click(function(){
    $('html,body').animate({ scrollTop: $($(this).attr("href")).offset().top }, 'slow','swing');
    return false;
  })
};

// Rails3でAjaxUpdate
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

// twitterのBlogParts
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

var googleAnalytics = function() {
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-22042269-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
};

$(function(){
  $('.socialButtons .hatena').socialbutton('hatena');
  $('.socialButtons .twitter').socialbutton('twitter', { button: 'horizontal', lang: 'en' });
  $('.socialButtons .facebook').socialbutton('facebook_like', { button: 'button_count', locale: 'en_US' });
  $('.images a').lightBox();
  bindRemote('.moreButton');
  bindSmoothScroll('#navi a');
});

$(function(){
  $('.socialButtons .hatena').socialbutton('hatena');
  $('.socialButtons .twitter').socialbutton('twitter', { button: 'horizontal', lang: 'en', related: 'ruedap' });
  $('.socialButtons .facebook').socialbutton('facebook_like', { button: 'button_count', locale: 'en_US' });
});

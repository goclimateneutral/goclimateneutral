import $ from 'jquery';

function initializeUsers() {
  function shareFacebook() {
    FB.ui({
      method: 'share',
      href: window.urlToShare,
      quote: window.facebookQuote,
      hashtag: '#goclimate'
    }, function(response){});
  }

  $('#share-facebook-bottom').click(function() {
    shareFacebook();
  });
};

window.initializeUsers = initializeUsers;

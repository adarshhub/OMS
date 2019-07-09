$(document).ready(function () {
    $('#gotoLogin').click(function () {
        $('#register-box').slideUp('slow', function () {
            $('#login-box').slideDown('slow');
        });
    });
    $('#gotoSignup').click(function () {
        $('#login-box').slideUp('slow', function () {
            $('#register-box').slideDown('slow');
        });
    });
});
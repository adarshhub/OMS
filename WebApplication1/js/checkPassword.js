function checkPassword(input) {
    var pass_pattern = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{7,15}$/;
    if (input.match(pass_pattern)) {
        return true;
    } else {
        return false;
    }
}

var change_password_btn = document.getElementById('change_password_btn');
change_password_btn.disabled = true;

var valid_new_password = false;
var confirm_password_match = false;
var new_password_form = document.getElementById('new_password_form');
var confirm_password_form = document.getElementById('confirm_password_form');
var new_password_invalid = document.getElementById('new_password_invalid');
var confirm_password_invalid = document.getElementById('confirm_password_invalid');

$('#new_password').on('input', function (e) {
    new_password_form.classList.add('has-danger');
    e.target.classList.add('is-invalid');
    new_password_form.classList.remove('has-success');
    e.target.classList.remove('is-valid');
    valid_new_password = false;

    if (e.target.value.length < 6) {
        new_password_invalid.innerText = "Length should be atleast 6";
    } else {
        if (!checkPassword(e.target.value)) {

            new_password_invalid.innerText = "Password should contain atleast 1 special character and 1 numeric";
        } else {

            new_password_form.classList.remove('has-danger');
            e.target.classList.remove('is-invalid');
            e.target.classList.add('is-valid');
            new_password_form.classList.add('has-success');
            valid_new_password = true;
        }
    }

    if (valid_new_password && confirm_password_match) {
        change_password_btn.disabled = false;
    } else {
        change_password_btn.disabled = true;
    }
});

$('#confirm_password').on('input', function (e) {
    confirm_password_match = false;

    confirm_password_form.classList.add('has-danger');
    e.target.classList.add('is-invalid');
    confirm_password_form.classList.remove('has-success');
    e.target.classList.remove('is-valid');

    if (new_password.value == e.target.value) {
        confirm_password_form.classList.remove('has-danger');
        e.target.classList.remove('is-invalid');
        confirm_password_form.classList.add('has-success');
        e.target.classList.add('is-valid');
        confirm_password_match = true;
    }

    if (valid_new_password && confirm_password_match) {
        change_password_btn.disabled = false;
    } else {
        change_password_btn.disabled = true;
    }
});
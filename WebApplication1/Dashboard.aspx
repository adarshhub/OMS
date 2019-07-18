<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebApplication1.WebForm4" %>

<%@ MasterType VirtualPath="~/User.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <ul class="nav nav-tabs">
        <li class="nav-item">
            <a class="nav-link active" data-toggle="tab" href="#home">Overall Capacity</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#profile">Profile</a>
        </li>
    </ul>
    <div id="myTabContent" class="tab-content">
        <div class="tab-pane fade show active" id="home">
            <div class="content">
                <div id="control_box" class="card border-secondary">

                    <div class="sa_controls_box">
                        <div class="row mb-2">
                            <div class="col-sm-4">
                                <div class="form-inline mb-2">
                                    <label class="col-sm-5">Plant Code:</label>
                                    <select id="DeptList" class="col-sm-7 form-control">
                                    </select>
                                </div>
                                <div class="form-inline mb-2">
                                    <label class="col-sm-5">Process Cntr:</label>
                                    <select id="ProcessCntrList" class="col-sm-7 form-control">
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-inline mb-2">
                                    <label class="col-sm-6">YRWK From:</label>
                                    <input id="yrwkFrom" class="form-control col-sm-5" type="number" />
                                </div>
                                <div class="form-inline mb-2">
                                    <label class="col-sm-6">YRWK To:</label>
                                    <input id="yrwkTo" class=" form-control col-sm-5" type="number" />

                                </div>
                            </div>
                            <div class="col-sm-1">
                                <input type="button" id="show_cap_table" class="btn btn-info mb-2" value="Show" onclick="fetch_table()" />
                                <input type="button" id="add_order_btn" class="btn btn-info mb-2" value="Add" onclick="addOrder()" />
                            </div>
                            <div class="col-sm-3">
                                <div class="form-inline mb-2">
                                    <label class="col-sm-6">Copy From:</label>
                                    <input id="copyFrom" class="form-control col-sm-5" type="number" />
                                </div>
                                <div class="form-inline mb-2">
                                    <label class="col-sm-6">Copy To:</label>
                                    <input id="copyTo" class=" form-control col-sm-5" type="number" />

                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="col-sm-6">
                                    <input type="button" id="copy_order_btn" class="btn btn-info" value="Copy" onclick="copyOrder()" />
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                <div id="display_box">
                    <!-- Order table Goes Here -->
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="profile">
            <h1 class="display-4">Hello,
                <asp:Label ID="profile_username" runat="server" Text="Name"></asp:Label>
                You are
                <asp:Label ID="isAdmin" runat="server" Text="Not Admin"></asp:Label></h1>
            <input type="button" class="btn btn-warning" value="Change Password" data-toggle="modal" data-target="#changePasswordModal" onclick="passwordChange()"/>
        </div>
        
        <div id="msg_box">
        </div>

        <!-- Change PAssword Popup -->
        <div class="modal" id="changePasswordModal">
            <div class="modal-dialog">
                <div class="modal-content">

                    <!-- Modal Header -->
                    <div class="modal-header">
                        <h4 class="modal-title">Change Password</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>

                    <!-- Modal body -->
                    <div class="modal-body">
                        <div class="form-inline mb-2">
                            <label class="col-sm-5">Current Password:</label>
                            <input id="current_password" class="form-control col-sm-6" type="password"/>
                        </div>
                        <div class="form-inline form-group mb-2" id="new_password_form">
                            <label class="col-sm-5">New Password:</label>
                            <input id="new_password" class=" form-control col-sm-6" />
                            <div class="invalid-feedback" id="new_password_invalid"></div>
                            <div class="valid-feedback" id="new_password_valid">Valid! Password</div>
                        </div>
                        <div class="form-inline form-group mb-2" id="confirm_password_form">
                            <label class="col-sm-5">Confirm Password:</label>
                            <input id="confirm_password" class=" form-control col-sm-6" type="password"/>
                            <div class="invalid-feedback" id="confirm_password_invalid">Password do not match</div>
                            <div class="valid-feedback" id="confirm_password_valid">Password Matched</div>
                        </div>
                    </div>


                    <!-- Modal footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                        <input type="button" id="change_password_btn" class="btn btn-danger" value="Change" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Pop up Add Feature  (Modal bootstrap)

        <div class="modal" id="addModal">
            <div class="modal-dialog">
                <div class="modal-content">

                    // Modal Header 
                    <div class="modal-header">
                        <h4 class="modal-title">Insert Order Details</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>

                    // Modal body
                    <div class="modal-body">
                        <div class="control_wrapper form-group">
                            <label class="control-label col-sm-5">Dept/Plant:</label>
                            <input id="add_dept_val" class="col-sm-5 form-control" type="text" required/>
                        </div>
                        <div class="control_wrapper form-group">
                            <label class="control-label col-sm-5">Process:</label>
                            <input id="add_process_val" class="col-sm-5 form-control" type="number" required/>
                        </div>
                        <div class="control_wrapper form-group">
                            <label class="control-label col-sm-5">Process Center:</label>
                            <input id="add_process_cntr_val" class="col-sm-5 form-control" type="number" required/>
                        </div>
                        <div class="control_wrapper form-group">
                            <label class="control-label col-sm-5">Year Week:</label>
                            <input id="add_yr_wk_val" class="col-sm-5 form-control" type="number" required/>
                        </div>
                        <div class="control_wrapper form-group">
                            <label class="control-label col-sm-5">total Quantity:</label>
                            <input id="add_total_avl_qnty_val" class="col-sm-5 form-control" type="number" required/>
                        </div>
                        <div class="control_wrapper form-group">
                            <label class="control-label col-sm-5">Order Quantity:</label>
                            <input id="add_order_qnty_val" class="col-sm-5 form-control" type="number" required/>
                        </div>
                    </div> 
            

                    // Modal footer 
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                        <input type="button" id="add_order_btn" class="btn btn-success" value="Confirm" onclick="addOrder()" />
                    </div>
            </div>
        </div>
    </div>
             -->

    </div>


    <!-- script -->

    <script type="text/javascript">

        var deptDDL = $('#DeptList');
        var processCntrDDL = $('#ProcessCntrList');
        var fromInput = document.getElementById('yrwkFrom');
        var toInput = document.getElementById('yrwkTo');

        var copyFrom_input = document.getElementById('copyFrom');
        var copyTo_input = document.getElementById('copyTo');

        var display_box = $('#display_box');               //Jquery DOM element
        var msg_box = document.getElementById("msg_box");
        var addBtn = document.getElementById('add_order_btn');

        

        if (isAdmin != 1) {
            $('#add_order_btn').attr("disabled", true);
            $('#copy_order_btn').attr("disabled", true);
        }

        function updateDropdownList() {

            deptDDL.empty();

            $.ajax({
                url: 'TableService.asmx/getDepatments',
                method: 'POST',
                dataType: 'json',
                success: function (data) {
                    deptDDL.append($('<option/>', { value: '-1', text: 'Select Plant' }));
                    processCntrDDL.append($('<option/>', { value: -1, text: 'Select Cntr' }));
                    processCntrDDL.prop('disabled', true);
                    $(data).each(function (index, item) {
                        deptDDL.append($('<option/>', { value: item, text: item }));
                    });
                }
            });

        }

        deptDDL.change(function () {

            processCntrDDL.empty();
            processCntrDDL.append($('<option/>', { value: -1, text: 'Select Cntr' }));

            if ($(this).val() == -1) {
                processCntrDDL.val(-1);
                processCntrDDL.prop('disabled', true);
            } else {

                $.ajax({
                    url: 'TableService.asmx/getProcessCntr',
                    method: 'POST',
                    data: { dept: $(this).val() },
                    dataType: 'json',
                    success: function (data) {
                        processCntrDDL.prop('disabled', false);
                        $(data).each(function (index, item) {
                            processCntrDDL.append($('<option/>', { value: item, text: item }));
                        });
                    }
                });
            }
        });

        updateDropdownList();

        function fetch_table() {

            var dept = deptDDL.val();
            var process_cntr = processCntrDDL.val();
            var from = fromInput.value == '' ? -1 : parseInt(fromInput.value);
            var to = toInput.value == '' ? -1 : parseInt(toInput.value);

            console.log(dept + ":" + process_cntr + ":" + from + ":" + to);

            var tableID, attr;

            if (isAdmin == 1)
                attr = "";
            else
                attr = "disabled";

            addBtn.disabled = false;

            $.ajax({
                url: 'TableService.asmx/getTable',
                method: 'POST',
                data: { dept: dept, process_cntr: process_cntr, from: from, to: to },
                dataType: 'json',
                success: function (data) {


                    display_box.empty();

                    if (data.length == 0) {
                        display_box.append('<div class="alert alert-dismissible alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">No Data Found!</h4><p class="mb-0">Check Input Data</p></div>');
                    }
                    else {

                        var table = '<table class="table" id="order_table"><thead><tr><th scope="col">Edit/Delete</th><th scope="col">Plant</th><th scope="col">Process Cntr</th><th scope="col">Process</th><th scope="col">Year Week</th><th scope="col">Total Capacity</th><th scope="col">AVL Quantity</th><th scope="col">Order Quantity</th></tr></thead><tbody>';

                        $(data).each(function (index, item) {
                            tableID = item["dept"] + ' ' + item["process"] + ' ' + item["process_cntr"] + ' ' + item["yr_wk"];

                            table += '<tr><td>' + '<span id="' + tableID + '_ED"><input type="button" class="btn btn-secondary tabFirst_btn btn-sm"  value="Edit" onclick="editOrder(\'' + item["dept"] + '\',\'' + item["process"] + '\',' + item["process_cntr"] + ',' + item["yr_wk"] + ',' + item["total_avl_qnty"] + ')" ' + attr + '/><input type="button" class="btn btn-danger btn-sm" value="Delete" onclick="deleteOrder(\'' + item["dept"] + '\',\'' + item["process"] + '\',' + item["process_cntr"] + ',' + item["yr_wk"] + ')" ' + attr + '/></span><span class="' + tableID + '_UC" hidden><input type="button" class="tabFirst_btn btn btn-secondary btn-sm"  value="Update"/><input type="button" class="btn btn-danger btn-sm" value="Cancel" /></span>' + '</td><td>' + item["dept"] + '</td><td>' + item["process_cntr"] + '</td><td>' + item["process"] + '</td><td>' + item["yr_wk"] + '</td><td><span id="' + tableID + ' text">' + item["total_avl_qnty"] + '</span><input id="' + tableID + ' input" class="tbl_input form-control col-sm" hidden/></td><td>' + item["avl_promise"] + '</td><td>' + item["order_qnty"] + '</td></tr>';
                        });

                        table += '</tbody></table>';
                        display_box.append(table);
                    }

                }
            });

        }

        function deleteOrder(dept, process, process_cntr, yr_wk) {
            $.ajax({
                url: 'TableService.asmx/deleteOrder',
                method: 'POST',
                data: { dept: dept, process: process, process_cntr: process_cntr, yr_wk: yr_wk },
                dataType: 'json',
                success: function (data) {

                    //Refresh Table
                    fetch_table();
                    //Refresh Dropdown List
                    updateDropdownList();

                    if (data == "false") {
                        var html = '<div class="alert alert-dismissible alert-warning"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0">Something Went Wrong</p></div>';
                        msg_box.innerHTML = html;
                    }
                }
            });
        }

        function editOrder(dept, process, process_cntr, yr_wk, oldValue) {

            var ID = dept + ' ' + process + ' ' + process_cntr + ' ' + yr_wk;

            var textID = ID + ' text';
            var inputID = ID + ' input';
            var edbtnID = ID + '_ED';
            var ucbtnID = ID + '_UC';

            var textET = document.getElementById(textID);
            var inputET = document.getElementById(inputID);
            var edbtnET = document.getElementById(edbtnID);
            var ucbtnET = edbtnET.nextSibling;               //choose by Id can be also used

            inputET.value = oldValue;

            textET.hidden = true;
            inputET.hidden = false;

            edbtnET.hidden = true;
            ucbtnET.hidden = false;


            ucbtnET.lastChild.addEventListener("click", function () {
                ucbtnET.hidden = true;
                edbtnET.hidden = false;

                inputET.hidden = true;
                textET.hidden = false;

            });

            ucbtnET.firstChild.addEventListener("click", function () {

                var newValue = inputET.value;

                $.ajax({
                    url: 'TableService.asmx/updateOrder',
                    method: 'POST',
                    data: { dept: dept, process: process, process_cntr: process_cntr, yr_wk: yr_wk, new_total_qnty: newValue },
                    dataType: 'json',
                    success: function (data) {

                        //Refresh Table
                        fetch_table();

                        if (data == "false") {
                            var html = '<div class="alert alert-dismissible alert-warning"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0">Something Went Wrong</p></div>';
                            msg_box.innerHTML = html;
                        }
                    }
                });
            });

        }

        var no_el_in_table = 0;

        function hide_add_inputs() {
            addBtn.disabled = false;

            if (no_el_in_table)
                display_box.empty();
            else {
                $("table[id='order_table']  > tbody > tr:first-child").remove();
            }

        }


        function addOrder() {
            addBtn.disabled = true;

            if (document.getElementById('order_table') == null) {
                no_el_in_table = 1;
                display_box.append('<table class="table" id="order_table"><thead><tr><th scope="col">Edit/Delete</th><th scope="col">Plant</th><th scope="col">Process Cntr</th><th scope="col">Process</th><th scope="col">Year Week</th><th scope="col">Total Capacity</th><th scope="col">AVL Quantity</th><th scope="col">Order Quantity</th></tr></thead><tbody></tbody></table>');
            }

            var order_table = $('#order_table');

            var html = '<tr><td><span class="addOrder_CC"><input type="button" id="confirm_addOrder_btn" class="tabFirst_btn btn btn-success btn-sm"  value="Confirm"/><input type="button" id="cancel_addOrder_btn" class="btn btn-danger btn-sm" value="Cancel" /></span></td><td><input id="add_dept_val" class="col-sm form-control tbl_input" type="text" required/></td><td><input id="add_process_cntr_val" class="col-sm form-control tbl_input" type="number" required/></td><td><input id="add_process_val" class="col-sm form-control tbl_input" type="text" required/></td><td><input id="add_yr_wk_val" class="col-sm form-control tbl_input" type="number" required/></td><td><input id="add_total_avl_qnty_val" class="col-sm form-control tbl_input" type="number" required/></td><td><input id="add_avl_promise_val" class="col-sm form-control tbl_input" type="number" required value="0" disabled/></td><td><input id="add_order_qnty_val" class="col-sm form-control tbl_input" type="number" required value="0" disabled/></td></tr>';

            order_table.find('tbody').prepend(html);

            document.getElementById('confirm_addOrder_btn').addEventListener('click', confirmOrder);

            document.getElementById('cancel_addOrder_btn').addEventListener('click', hide_add_inputs);

        }

        function confirmOrder() {

            var dept = document.getElementById("add_dept_val").value;
            var process = document.getElementById("add_process_val").value;
            var process_cntr = document.getElementById("add_process_cntr_val").value;
            var yr_wk = document.getElementById("add_yr_wk_val").value;
            var total_avl_qnty = document.getElementById("add_total_avl_qnty_val").value;
            var order_qnty = document.getElementById("add_order_qnty_val").value;

            var order = {};

            order.dept = dept;
            order.process = process;
            order.process_cntr = process_cntr;
            order.yr_wk = yr_wk;
            order.total_avl_qnty = total_avl_qnty;
            order.order_qnty = order_qnty;

            if (dept == '' || process == '' || process_cntr == '' || yr_wk == '' || yr_wk < 100000 || yr_wk > 999999 || isNaN(yr_wk) || isNaN(total_avl_qnty) || isNaN(process_cntr) || process_cntr <100 || process_cntr > 999) {

                msg_box.innerHTML = '<div class="alert alert-dismissible alert-warning"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0">Invalid or empty input</p></div>';
            }
            else {

                $.ajax({
                    url: 'TableService.asmx/addOrder',
                    method: 'POST',
                    data: { jsonOrder: JSON.stringify(order) },
                    dataType: 'json',
                    success: function (data) {

                        hide_add_inputs();

                        var html;

                        if (data != "true") {
                            html = '<div class="alert alert-dismissible alert-warning"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0">' + data + '</p></div>';

                        } else { 
                            html = '<div class="alert alert-dismissible alert-success"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Successfull!</h4><p class="mb-0">New Order Added</p></div>';
                            updateDropdownList();
                        }

                        msg_box.innerHTML = html;

                    }
                });
            }

        }

        function copyOrder() {

            
            var dept = deptDDL.val().toString();
            var process_cntr = parseInt(processCntrDDL.val());
            var copyFrom = parseInt(copyFrom_input.value);
            var copyTo = parseInt(copyTo_input.value);

            console.log(dept);
            console.log(process_cntr);
            console.log(copyFrom);


            if (isNaN(copyFrom) || isNaN(copyTo) || copyFrom < 100000 || copyTo < 100000 || copyFrom > 999999 || copyTo > 999999) {
                msg_box.innerHTML = '<div class="alert alert-dismissible alert-warning"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0"> Enter Required fields</p></div>';
            } else {

                $.ajax({
                    url: 'TableService.asmx/copyOrder',
                    method: 'POST',
                    data: { dept: dept, process_cntr: process_cntr, copyFrom: copyFrom, copyTo: copyTo},
                    dataType: 'json',
                    success: function (data) {

                        var html;

                        if (data != "true") {
                            html = '<div class="alert alert-dismissible alert-warning"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0">' + data + '</p></div>';

                        } else {
                            html = '<div class="alert alert-dismissible alert-success"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Successfull!</h4><p class="mb-0">Old Order Copied</p></div>';
                        }

                        msg_box.innerHTML = html;

                    }
                });
            }
        }

        function checkPassword(input) {
            var pass_pattern = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{7,15}$/;
            if (input.match(pass_pattern)) {
                return true;
            } else {
                return false;
            }
        }

        var current_password = document.getElementById('current_password');
        var new_password = document.getElementById('new_password');
        var confirm_password = document.getElementById('confirm_password');

        function passwordChange() {      

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

            document.getElementById('change_password_btn').addEventListener('click', function () {

                $('#changePasswordModal').modal('hide');

                $.ajax({
                    url: 'TableService.asmx/change_password',
                    method: 'POST',
                    data: { current_password: current_password.value, new_password: new_password.value },
                    dataType: 'json',
                    success: function (data) {
                        console.log(data);

                        var html;

                        if (data != "true") {
                            html = '<div class="alert alert-dismissible alert-warning"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0">' + data + '</p></div>';

                        } else {
                            html = '<div class="alert alert-dismissible alert-success"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Successfull!</h4><p class="mb-0">Password Changed</p></div>';
                        }

                        msg_box.innerHTML = html;
                    }
                });
            });
        }


    </script>
</asp:Content>

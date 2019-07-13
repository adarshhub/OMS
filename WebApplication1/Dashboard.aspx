<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebApplication1.WebForm4" %>

<%@ MasterType VirtualPath="~/User.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">


        $(document).ready(function () {

            var deptDDL = $('#DeptList');
            var processDDL = $('#ProcessList');
            var tableSQL = "";

            if (isAdmin != 1) {
                $('#add_order_btn').attr("disabled", true);
            }

            $.ajax({
                url: 'TableService.asmx/getDepatments',
                method: 'POST',
                dataType: 'json',
                success: function (data) {
                    deptDDL.append($('<option/>', { value: -1, text: 'Select Department' }));
                    processDDL.append($('<option/>', { value: -1, text: 'Select Process' }));
                    processDDL.prop('disabled', true);
                    $(data).each(function (index, item) {
                        deptDDL.append($('<option/>', { value: item, text: item }));
                    });
                }
            });

            deptDDL.change(function () {

                processDDL.empty();
                processDDL.append($('<option/>', { value: -1, text: 'Select Process' }));

                if ($(this).val() == -1) {
                    processDDL.val(-1);
                    processDDL.prop('disabled', true);
                } else {

                    $.ajax({
                        url: 'TableService.asmx/getProcess',
                        method: 'POST',
                        data: { dept: $(this).val() },
                        dataType: 'json',
                        success: function (data) {
                            processDDL.prop('disabled', false);
                            $(data).each(function (index, item) {
                                processDDL.append($('<option/>', { value: item, text: item }));
                            });
                        }
                    });
                }
            });
        });




    </script>
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
                <div id="control_box" class="card border-secondary mb-3">
                    <table>
                        <tr>
                            <td>
                                <div class="dropdown_box">

                                    <div class="control_wrapper">
                                        <label class="control-label col-sm-6">Plant Code:</label>
                                        <select id="DeptList" class="dropdown col-sm-8">
                                        </select>
                                    </div>
                                    <div class="control_wrapper">
                                        <label class="control-label col-sm-6">Process Code:</label>
                                        <select id="ProcessList" class="dropdown col-sm-8">
                                        </select>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="time_box">

                                    <div class="control_wrapper form-group">
                                        <label class="control-label col-sm-5">YRWK From:</label>
                                        <input id="yrwkFrom" class="col-sm-5 form-control" type="number" />
                                    </div>
                                    <div class="control_wrapper form-group">
                                        <label class="control-label col-sm-5">YRWK To:</label>
                                        <input id="yrwkTo" class="col-sm-5 form-control" type="number" />
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <div id="buttons_box">
                        <div id="left_btns_box">
                            <input type="button" id="show_cap_table" class="btn btn-info" value="Show" onclick="fetch_table()" />
                            <input type="button" id="add_order_btn" class="btn btn-info" value="Add" onclick="addOrder()" />
                        </div>
                        <div id="right_btns_box">
                            <div class="control_wrapper form-group">
                                <label class="control-label col-sm-3">YRWK:</label>
                                <input id="copy_yr_wk" class="col-sm-5 form-control" type="number" required />
                            </div>
                            <input type="button" id="copy_order_btn" class="btn btn-info" value="Copy" onclick="copyOrder()" />
                        </div>

                    </div>

                </div>
                <div id="display_box">
                    <!-- Order table Goes Here -->
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="profile">
            <h1 class="display-3">Hello,
                <asp:Label ID="profile_username" runat="server" Text="Name"></asp:Label>
                You are
                <asp:Label ID="isAdmin" runat="server" Text="Not Admin"></asp:Label></h1>
        </div>
        <div id="msg_box">
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
                            <input id="add_dept_val" class="col-sm-5 form-control" type="number" required/>
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
             -->

    </div>
    </div>
        </div>
    </div>

    <!-- script -->

    <script type="text/javascript">

        var deptDDL = document.getElementById('DeptList');
        var processDDL = document.getElementById('ProcessList');
        var fromInput = document.getElementById('yrwkFrom');
        var toInput = document.getElementById('yrwkTo');

        var display_box = $('#display_box');               //Jquery DOM element
        var msg_box = document.getElementById("msg_box");
        var addBtn = document.getElementById('add_order_btn');

        function fetch_table() {

            var dept = deptDDL.value;
            var process = processDDL.value;
            var from = fromInput.value == '' ? -1 : parseInt(fromInput.value);
            var to = toInput.value == '' ? -1 : parseInt(toInput.value);

            var tableID, attr;

            if (isAdmin == 1)
                attr = "";
            else
                attr = "disabled";

            addBtn.disabled = false;

            $.ajax({
                url: 'TableService.asmx/getTable',
                method: 'POST',
                data: { dept: dept, process: process, from: from, to: to },
                dataType: 'json',
                success: function (data) {


                    display_box.empty();

                    if (data.length == 0) {
                        display_box.append('<div class="alert alert-dismissible alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">No Data Found!</h4><p class="mb-0">Check Input Data</p></div>');
                    }
                    else {

                        var table = '<table class="table" id="order_table"><thead><tr><th scope="col">Edit/Delete</th><th scope="col">Dept</th><th scope="col">Process Cntr</th><th scope="col">Process</th><th scope="col">Year Week</th><th scope="col">Total Capacity</th><th scope="col">AVL Quantity</th><th scope="col">Order Quantity</th></tr></thead><tbody>';

                        $(data).each(function (index, item) {
                            tableID = item["dept"] + ' ' + item["process"] + ' ' + item["process_cntr"] + ' ' + item["yr_wk"];

                            table += '<tr><td>' + '<span id="' + tableID + '_ED"><input type="button" class="btn btn-secondary tabFirst_btn btn-sm"  value="Edit" onclick="editOrder(' + item["dept"] + ',' + item["process"] + ',' + item["process_cntr"] + ',' + item["yr_wk"] + ',' + item["total_avl_qnty"] + ')" ' + attr + '/><input type="button" class="btn btn-danger btn-sm" value="Delete" onclick="deleteOrder(' + item["dept"] + ',' + item["process"] + ',' + item["process_cntr"] + ','+item["yr_wk"]+ ')" ' + attr + '/></span><span class="' + tableID + '_UC" hidden><input type="button" class="tabFirst_btn btn btn-secondary btn-sm"  value="Update"/><input type="button" class="btn btn-danger btn-sm" value="Cancel" /></span>' + '</td><td>' + item["dept"] + '</td><td>' + item["process_cntr"] + '</td><td>' + item["process"] + '</td><td>' + item["yr_wk"] + '</td><td><span id="' + tableID + ' text">' + item["total_avl_qnty"] + '</span><input id="' + tableID + ' input" class="tbl_input form-control col-sm-1" hidden/></td><td>' + item["avl_promise"] + '</td><td>' + item["order_qnty"] + '</td></tr>';
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

                    if (data == "false") {
                        var html = '<div class="alert alert-dismissible alert-warning"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0">Something Went Wrong</p></div>';
                        msg_box.innerHTML = html;
                    }
                }
            });
        }

        function editOrder(dept, process, process_cntr, yr_wk, oldValue) {

            var ID = dept + ' ' + process + ' ' + process_cntr+ ' ' + yr_wk;

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
                display_box.append('<table class="table" id="order_table"><thead><tr><th scope="col">Edit/Delete</th><th scope="col">Dept</th><th scope="col">Process Cntr</th><th scope="col">Process</th><th scope="col">Year Week</th><th scope="col">Total Capacity</th><th scope="col">AVL Quantity</th><th scope="col">Order Quantity</th></tr></thead><tbody></tbody></table>');
            }

            var order_table = $('#order_table');

            var html = '<tr><td><span class="addOrder_CC"><input type="button" id="confirm_addOrder_btn" class="tabFirst_btn btn btn-success btn-sm"  value="Confirm"/><input type="button" id="cancel_addOrder_btn" class="btn btn-danger btn-sm" value="Cancel" /></span></td><td><input id="add_dept_val" class="col-sm-1 form-control tbl_input" type="number" required/></td><td><input id="add_process_cntr_val" class="col-sm-1 form-control tbl_input" type="number" required/></td><td><input id="add_process_val" class="col-sm-1 form-control tbl_input" type="number" required/></td><td><input id="add_yr_wk_val" class="col-sm-1 form-control tbl_input" type="number" required/></td><td><input id="add_total_avl_qnty_val" class="col-sm-1 form-control tbl_input" type="number" required/></td><td><input id="add_avl_promise_val" class="col-sm-1 form-control tbl_input" type="number" required/></td><td><input id="add_order_qnty_val" class="col-sm-1 form-control tbl_input" type="number" required/></td></tr>';
            order_table.find('tbody').prepend(html);

            document.getElementById('add_dept_val').value = deptDDL.value;
            document.getElementById('add_process_val').value = processDDL.value;

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

            // $('#addModal').modal('hide');

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
                    }

                    msg_box.innerHTML = html;

                }
            });

        }

        function copyOrder() {

            var changeTo = document.getElementById('copy_yr_wk').value;
            var dept = deptDDL.value;
            var process = processDDL.value;
            var oldFrom = fromInput.value;
            var oldTo = toInput.value == "" ? 0 : parseInt(toInput.value);


            if (changeTo == "" || oldFrom == "" || dept == "" || process == "") {
                msg_box.innerHTML = '<div class="alert alert-dismissible alert-warning"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0"> Enter Required fields</p></div>';
            } else {



                $.ajax({
                    url: 'TableService.asmx/copyOrder',
                    method: 'POST',
                    data: { dept: dept, process: process, oldFrom: oldFrom, oldTo: oldTo, newTo: changeTo },
                    dataType: 'json',
                    success: function (data) {

                        var html;

                        if (data != "true") {
                            html = '<div class="alert alert-dismissible alert-warning"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0">' + data + '</p></div>';

                        } else {
                            html = '<div class="alert alert-dismissible alert-success"  ><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">Successfull!</h4><p class="mb-0">New Order Added</p></div>';
                        }

                        msg_box.innerHTML = html;

                    }
                });
            }
        }
    </script>
</asp:Content>

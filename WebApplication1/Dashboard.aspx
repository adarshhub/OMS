<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebApplication1.WebForm4" %>

<%@ MasterType VirtualPath="~/User.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">


        $(document).ready(function () {

            var deptDDL = $('#DeptList');
            var processDDL = $('#ProcessList');
            var tableSQL = "";

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


        function fetch_table() {

            var deptDDL = document.getElementById('DeptList');
            var processDDL = document.getElementById('ProcessList');
            var fromInput = document.getElementById('yrwkFrom');
            var toInput = document.getElementById('yrwkTo');

            var dept = deptDDL.value;
            var process = processDDL.value;
            var from = fromInput.value == '' ? -1 : parseInt(fromInput.value);
            var to = toInput.value == '' ? -1 :parseInt(toInput.value);

            $.ajax({
                url: 'TableService.asmx/getTable',
                method: 'POST',
                data: {dept: dept, process: process, from: from, to: to},
                dataType: 'json',
                success: function (data) {

                    var display_box = $('#display_box');
                    display_box.empty();

                    if (data.length == 0) {
                        display_box.append('<div class="alert alert-dismissible alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button><h4 class="alert-heading">No Data Found!</h4><p class="mb-0">Check Input Data</p></div>');
                    }
                    else {
                        
                        var table = '<table class="table"><thead><tr><th scope="col">Edit/Delete</th><th scope="col">Process</th><th scope="col">Year Week</th><th scope="col">Total Capacity</th><th scope="col">AVL Quantity</th><th scope="col">Order Quantity</th></tr></thead><tbody>';
                        $(data).each(function (index, item) {
                            table += '<tr><td>' + '<span class="edit_delete"><input type="button" class="btn btn-secondary editOrder_btn"  value="Edit" onclick="editOrder(' + item["dept"] + ',' + item["process"] + ',' + item["process_cntr"] + ')"/><input type="button" class="btn btn-danger" value="Delete" /></span>' + '</td><td>' + item["process"] + '</td><td>' + item["yr_wk"] + '</td><td>' + item["total_avl_qnty"] + '</td><td>' + item["avl_promise"] + '</td><td><span id="' + item["dept"] + ' ' + item["process"] + ' ' + item["process_cntr"] + ' text">' + item["order_qnty"] + '</span><input id="' + item["dept"] + ' ' + item["process"] + ' ' + item["process_cntr"] + ' input" class="form-control" hidden/></td></tr>';
                        });

                        table += '</tbody></table>';
                        display_box.append(table);
                    }
                    
                }
            });

        }

        function editOrder(dept, process, process_cntr) {

            var textID =  dept + ' ' + process + ' ' + process_cntr + ' text';
            var inputID =  dept + ' ' + process + ' ' + process_cntr + ' input';
            
            var textET = document.getElementById(textID);
            var inputET = document.getElementById(inputID);

            console.log(textET);

            textET.hidden = true;
            inputET.hidden = false;

            $.ajax({
                url: 'TableService.asmx/updateOrder',
                method: 'POST',
                data: {dept: dept, process: process, process_cntr: process_cntr},
                dataType: 'json',
                success: function (data) {
                    console.log(data);
                }
            });
        }
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
                                        <input id="yrwkFrom" class="col-sm-5 form-control" type="number"/>
                                    </div>
                                    <div class="control_wrapper form-group">
                                        <label class="control-label col-sm-5">YRWK To:</label>
                                        <input id="yrwkTo" class="col-sm-5 form-control" type="number"/>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <input type="button" id="show_cap_table" class="btn btn-info" value="Show" onclick="fetch_table()"/>
                    
                </div>
                <div id="display_box">
                    <asp:GridView ID="TableView" runat="server">
                    </asp:GridView>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="profile">
            <h1 class="display-3">Hello, <asp:Label ID="profile_username" runat="server" Text="Name"></asp:Label> You are <asp:Label ID="isAdmin" runat="server" Text="Not Admin"></asp:Label></h1>
        </div>
    </div>
</asp:Content>

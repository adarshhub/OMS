<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="SecurityCheck.aspx.cs" Inherits="WebApplication1.WebForm3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="form1" runat="server">
    <h1 class="display-2">Forgot Password</h1>
    <div class="form-group">
        <label>EID:</label>
        <input class="form-control" id="forgot_eid" />
    </div>
    <input type="button" value="Find" class="btn btn-primary" onclick="findEID()" />
    <br />
    <br />
     <h2 class="h2" id="forgot_username"></h2>
    <div id="security_box" class="card border-secondary p-3" hidden>
        <div class="form-group">
            <label id="security_question"></label>
            <input class="form-control" id="security_answer" />
        </div>
        <input type="button" value="Reset" class="btn btn-warning" onclick="checkAnswer()" />
    </div>
    <script>
        var eid_input = document.getElementById('forgot_eid');
        var eid;
        function findEID() {
             eid = parseInt(eid_input.value);
            var security_box = document.getElementById('security_box');
            var security_question = document.getElementById('security_question');

            $.ajax({
                url: 'TableService.asmx/checkEID',
                method: 'POST',
                data: { eid: eid },
                dataType: 'json',
                success: function (data) {
                    var username_field = document.getElementById('forgot_username');
                    if (data == "false") {
                        username_field.innerText = "Not Found";
                        security_box.hidden = true;
                    } else {
                        security_question.innerText = data["question"];
                        username_field.innerText = data["username"];
                        security_box.hidden = false;
                    }
                }
            });
        }


        function checkAnswer() {

            var security_answer = document.getElementById('security_answer').value;
            
            $.ajax({
                url: 'TableService.asmx/checkSecurityAnswer',
                method: 'POST',
                data: { eid: eid, answer: security_answer},
                dataType: 'json',
                success: function (data) {
                    
                    if (data == "false") {
                        document.getElementById('ms_msg_box').innerHTML = '<div class="alert alert-dismissible alert-warning"  ><h4 class="alert-heading">Not Successfull!</h4><p class="mb-0">Incorrect</p></div>';
                    } else {
                        window.location.href = "ResetPassword.aspx";
                    }
                }
            });
        }
    </script>
</asp:Content>

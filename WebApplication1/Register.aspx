<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebApplication1.WebForm2" %>
<%@ MasterType  virtualPath="~/Site1.Master"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="form1" runat="server">
      <div id="register_box">
        <h1 class="h1">Register</h1>
        <form id="Form1" runat="server" class="form-horizontal">
            <div class="form-group">
                <asp:Label runat="server" Text="Username"></asp:Label>
                <asp:TextBox CssClass="form-control" ID="register_un" runat="server" required ViewStateMode="Enabled"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:Label runat="server" Text="EID"></asp:Label>
                <asp:TextBox CssClass="form-control" ID="register_eid" runat="server" required ViewStateMode="Enabled"></asp:TextBox>
            </div>
            <div class="form-group" id="password_form">
                <asp:Label runat="server" Text="Password"></asp:Label>
                <asp:TextBox class="form-control" ID="register_password1" runat="server" required></asp:TextBox>
                 <div class="invalid-feedback" id="password_form_invalid"></div>
                 <div class="valid-feedback" id="password_form_valid">Valid! Password</div>
            </div>
            <div class="form-group">
                <asp:Label runat="server" Text="Confirm Password"></asp:Label>
                <asp:TextBox class="form-control" ID="register_password2" runat="server" TextMode="Password" required></asp:TextBox>
            </div>
            <asp:Button ID="register_button" CssClass="btn btn-primary" runat="server" Text="Register" OnClick="register_button_Click" />
            <br />
            <asp:HyperLink ID="gotoLogin" runat="server" NavigateUrl="~/Login.aspx">Login Here</asp:HyperLink>
        </form>
    </div>
    <script type="text/javascript">
        var password_form = document.getElementById('password_form');
        var invalid_msg = document.getElementById('password_form_invalid');

        function checkPassword(input){
            var pass_pattern = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{7,15}$/;
            if (input.match(pass_pattern)) {
                return true;
            } else {
                return false;
            }
        }
        

        $('#form1_register_password1').on('input', function (e) {
            password_form.classList.add('has-danger');
            e.target.classList.add('is-invalid');
            password_form.classList.remove('has-success');
            e.target.classList.remove('is-valid');

            if (e.target.value.length < 6) {
                invalid_msg.innerText = "Length should be atleast 6";
            } else {
                if (!checkPassword(e.target.value)) {

                    invalid_msg.innerText = "Password should contain atleast 1 special character and 1 numeric";
                } else {

                    password_form.classList.remove('has-danger');
                    e.target.classList.remove('is-invalid');
                    e.target.classList.add('is-valid');
                    password_form.classList.add('has-success');
                }
            }
        });

       
    </script>
</asp:Content>

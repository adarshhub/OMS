<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication1.WebForm1" %>

<%@ MasterType VirtualPath="~/Site1.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="form1" runat="server">
    <div id="login_box">
        <h1 class="h1">Login</h1>
        <form id="loginForm" runat="server" class="form-horizontal">
            <div class="form-group">
                <asp:Label runat="server" Text="EID"></asp:Label>
                <asp:TextBox CssClass="form-control" ID="login_eid" runat="server" required ViewStateMode="Enabled"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:Label runat="server" Text="Password"></asp:Label>
                <asp:TextBox class="form-control" ID="login_password" runat="server" TextMode="Password" required></asp:TextBox>
            </div>
            <asp:Button ID="login_btn" CssClass="btn btn-primary" runat="server" Text="LogIn" OnClick="login_btn_Click" />
            <br />
            <asp:HyperLink ID="gotoSignup" runat="server" NavigateUrl="~/Register.aspx">Register Here</asp:HyperLink>
             <br />
            <asp:HyperLink runat="server" NavigateUrl="~/SecurityCheck.aspx">Forgot Password</asp:HyperLink>
        </form>

    </div>
</asp:Content>

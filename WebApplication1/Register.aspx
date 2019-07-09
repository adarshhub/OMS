<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebApplication1.WebForm2" %>
<%@ MasterType  virtualPath="~/Site1.Master"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <div id="register_box">
        <h1 class="h1">Register</h1>
        <form id="Form1" runat="server" class="form-horizontal">
            <div class="form-group">
                <asp:Label runat="server" Text="Username"></asp:Label>
                <asp:TextBox CssClass="form-control" ID="register_un" runat="server" required ViewStateMode="Enabled"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:Label runat="server" Text="Email"></asp:Label>
                <asp:TextBox CssClass="form-control" ID="register_email" runat="server" required ViewStateMode="Enabled"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:Label runat="server" Text="Password"></asp:Label>
                <asp:TextBox class="form-control" ID="register_password1" runat="server" TextMode="Password" required></asp:TextBox>
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
</asp:Content>

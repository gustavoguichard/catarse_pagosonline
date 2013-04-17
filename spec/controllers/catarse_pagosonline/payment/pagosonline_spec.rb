require 'spec_helper'

describe CatarsePagosonline::Payment::PagosonlineController do

  describe "notifications" do
    it "should 404 status code when not passed the 'Notification' param" do
      post :notifications, {use_route: :catarse_pagosonline}
      response.status.should == 404
    end

    it "should 200 status code when pass the 'Notification' param" do
      post :notifications, {Notificacion: fixture_file("pagosonline_ipn_request.xml"), use_route: :catarse_pagosonline}
      response.status.should == 200
    end

    it "should confirm the backer" do
      backer = Factory(:backer, payment_token: "ade4206f68ce02024ae1", confirmed: false)
      backer.confirmed.should be_false
      stub_post("/Vender/Consulta_IPN.asp", "pagosonline_ipn_response.xml", {:url => {:https => false}, country: PagosonlineCheckout::Configuration.country_name(::Configuration[:pagosonline_country_id])})
      post :notifications, {Notificacion: fixture_file("pagosonline_ipn_request.xml"), use_route: :catarse_pagosonline}
      backer.reload
      backer.confirmed.should be_true
    end
  end

  describe "pay" do
    it "should redirect" do
      backer = Factory(:backer, confirmed: false)
      sign_in backer.user
      post :pay, {id: backer, use_route: :catarse_pagosonline}
      response.should be_redirect
    end

    it "should set the payment_token" do
      backer = Factory(:backer, confirmed: false)
      sign_in backer.user
      backer.payment_token.should be_nil
      post :pay, {id: backer, use_route: :catarse_pagosonline}
      backer.reload
      backer.payment_token.should_not be_nil
      response.should be_redirect
    end
  end

  describe "success" do
    it "should redirect to thank you path" do
      backer = Factory(:backer, confirmed: false)
      sign_in backer.user
      post :success, {id: backer, use_route: :catarse_pagosonline}
      response.should redirect_to(thank_you_path)
    end
  end

  describe "error" do
    it "should redirect to new project backer path" do
      backer = Factory(:backer, confirmed: false)
      sign_in backer.user
      post :error, {id: backer, use_route: :catarse_pagosonline}
      response.should redirect_to(new_project_backer_path(backer.project))
    end
  end

end

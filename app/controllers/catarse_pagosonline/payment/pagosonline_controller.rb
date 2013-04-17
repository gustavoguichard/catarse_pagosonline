module CatarsePagosonline
  module Payment
    class PagosonlineController < ApplicationController
      skip_before_filter :verify_authenticity_token, :only => [:notifications]
      skip_before_filter :detect_locale, :only => [:notifications]
      skip_before_filter :set_locale, :only => [:notifications]
      before_filter :initialize_pagosonline
      SCOPE = "projects.backers.checkout"

      def pay
        begin
          backer = current_user.backs.not_confirmed.find params[:id]
          if backer
            transaction_id = (Digest::MD5.hexdigest "#{SecureRandom.hex(5)}-#{DateTime.now.to_s}")[1..20].downcase
            backer.update_attribute :payment_method, 'Pagosonline'
            backer.update_attribute :payment_token, transaction_id
            data = PagosonlineCheckout::CheckoutData.validate({item_name_1: t('pagosonline_description', scope: SCOPE),
                                                              item_quantity_1: 1,
                                                              item_currency_1: PagosonlineCheckout.configuration.currency,
                                                              change_quantity: 0,
                                                              item_ammount_1: backer.moip_value,
                                                              buyer_name: backer.user.full_name,
                                                              buyer_phone: backer.user.phone_number,
                                                              buyer_email: backer.user.email,
                                                              ok_url: success_payment_pagosonline_url(backer),
                                                              error_url: error_payment_pagosonline_url(backer),
                                                              transaction_id: transaction_id})
            redirect_to PagosonlineCheckout::Client.get_uri(data)
          end
        rescue Exception => e
          Airbrake.notify({ :error_class => "Pagosonline Error", :error_message => "Pagosonline Error: #{e.inspect}", :parameters => params}) rescue nil
          Rails.logger.info "-----> #{e.inspect}"
          flash[:failure] = t('pagosonline_error', scope: SCOPE)
          return redirect_to main_app.new_project_backer_path(backer.project)
        end
      end

      def success
        backer = current_user.backs.find params[:id]
        session[:thank_you_id] = backer.project.id
        session[:_payment_token] = backer.payment_token

        flash[:success] = t('success', scope: SCOPE)
        redirect_to main_app.thank_you_path
      end

      def error
        backer = current_user.backs.find params[:id]
        flash[:failure] = t('pagosonline_error', scope: SCOPE)
        redirect_to main_app.new_project_backer_path(backer.project)
      end

      def notifications
        notification = params[:Notificacion]
        Rails.logger.info params.inspect
        return render(status: 404, nothing: true) if notification.nil?

        xml = Nokogiri::XML(notification.downcase)
        ids = []
        xml.xpath("//operacion//id").each {|o| ids << o.children.text}

        c = PagosonlineIpn::Client.new(account: ::Configuration[:pagosonline_merchant], password: ::Configuration[:pagosonline_ipn_password], pais: PagosonlineCheckout::Configuration.country_name(::Configuration[:pagosonline_country_id].to_i))
        reports = c.consulta_transacciones(ids).reports
        if reports
          reports.each do |report|
            begin
              backer = Backer.not_confirmed.where(payment_token: report.id).first
              backer.confirm! if backer and report.transaction_completed?
            rescue Exception => e
              Rails.logger.info "-----> #{e.inspect}"
            end
          end
        end
        render nothing: true
      end

      protected
      def initialize_pagosonline
        PagosonlineCheckout.configure do |config|
          config.payment_method = 'all'
          config.merchant = (::Configuration[:pagosonline_merchant] || nil)
          config.logo_url = "#{request.protocol}#{request.host_with_port}/assets/logo.png"
          config.currency = ::Configuration[:pagosonline_currency]
          config.country_id = ::Configuration[:pagosonline_country_id]
        end
      end

    end
  end
end


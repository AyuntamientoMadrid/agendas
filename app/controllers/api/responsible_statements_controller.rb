require 'nokogiri'

module Api
  class ResponsibleStatementsController < ApplicationController
    soap_service namespace: "http://wsintbrg.bareg.iam",
                 wsdl_style: :document,
                 wsse_username: "username",
                 wsse_password: "password"

    before_filter :parse_request, only: :inicioExpediente
    soap_action "inicioExpediente",
                args: {
                  codTipoExpediente: :string,
                  xmlDatosEntrada: :string,
                  listDocs: [ idDocumento: :string ],
                  listFormatos: [ idTipoDocumento: :string ],
                  usuario: :string
                },
                return: {
                  codRetorno: :string,
                  descError: :string,
                  idExpediente: :integer,
                  refExpediente: :string
                }
    def inicioExpediente
      responsible_statement = Nokogiri.XML(params[:xmlDatosEntrada])
      #TODO:  build organization from received responsible statement, save and respond
      puts responsible_statement

      render soap: {
        codRetorno: "",
        descError: "OK",
        idExpediente: "idExpediente",
        refExpediente: "refExpediente",
      }
    end

    private

    def parse_request
      if params[:codTipoExpediente].blank?
        render_error "codTipoExpediente cannot be blank"
      elsif params[:xmlDatosEntrada].blank?
        render_error "xmlDatosEntrada cannot be blank"
      elsif params[:usuario].blank?
        render_error "usuario cannot be blank"
      end
    end

    def render_error(descError)
      render soap: {
        codRetorno: 0,
        descError: descError,
      }
    end

  end
end

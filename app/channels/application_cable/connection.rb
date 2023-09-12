module ApplicationCable
  class Connection < ActionCable::Connection::Base

    def connect

      logger.info "asdf #{request.remote_ip}"
    end
  end
end

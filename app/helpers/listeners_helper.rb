module ListenersHelper
    def listener_group_name listener_id
        Listener.find(listener_id).group_name unless listener_id.blank?
    end
end

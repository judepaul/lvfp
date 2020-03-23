module ListenersHelper
    def listener_group_name listener_id
        Listener.find(listener_id).group_name
    end
end

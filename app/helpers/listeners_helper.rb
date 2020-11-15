module ListenersHelper
    def listener_group_name listener_id
        Listener.find_by_hashid(listener_id).group_name unless listener_id.blank?
    end
end

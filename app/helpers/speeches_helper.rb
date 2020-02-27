module SpeechesHelper
    def articlel_count access_code_id
        AccessCodeSpeechMap.where(access_code_id: access_code_id).count
    end
end

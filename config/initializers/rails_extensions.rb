class Array
    def random_twenty
        trails = self
        result = []
        trails.shuffle!

        trails.each do |trail|
            if result.length < 20
                result << trail
            else
                break
            end
        end
        result
    end
end
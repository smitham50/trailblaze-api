class Array
    def random_ten
        trails = self
        result = []
        trails.shuffle!

        trails.each do |trail|
            if result.length < 10
                result << trail
            else
                break
            end
        end
        result
    end
end
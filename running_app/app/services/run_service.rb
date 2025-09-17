module RunService
  module Base
    def self.filter_runs(params)
      page = params[:page] || 1
      per_page = params[:per_page] || 10

      begin
        offset = (page.to_i - 1) * per_page.to_i
        runs = Run.offset(offset).limit(per_page)
      rescue ActiveRecord::RecordInvalid => exception
        return ServiceContract.error(run.errors.full_messages) unless run.valid?
      end

      ServiceContract.success(runs)
    end
  end
end
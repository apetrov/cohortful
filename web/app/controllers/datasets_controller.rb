class DatasetsController < ApplicationController
  def new
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.new(dataset_params)
    file = dataset_file

    Dataset.transaction do
      @dataset.save!
      create_dataset = CreateDataset.new(Datalake.instance)
      @dataset.url = create_dataset.csv_to_parquet(
        file.path,
        @dataset,
      )
      @dataset.save!

      BackgroundJob.create(queue: 'inference', payload: {
        dataset_id: @dataset.id,
        url: @dataset.url,
        webhook_url: "https://cohortful.com/webhooks/inference_complete/#{@dataset.id}",
      })
    end


    redirect_to new_dataset_path, notice: "Dataset stored and ingested into DuckDB."
  end

  private

  def dataset_params
    params.require(:dataset).permit(:feature_name, :arpu_name, :arpu_std_name, :size_name)
  end

  def dataset_file
    params.require(:dataset).require(:file)
  end

  def handle_failure(message)
    flash.now[:alert] = message
    render :new, status: :unprocessable_entity
  end
end

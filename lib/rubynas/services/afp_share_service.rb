class AfpShareService < ShareService
  service_name :netatalk

  def update!
    if AfpServiceConfiguration.update
      restart # supplied by base class
    end
  end
end

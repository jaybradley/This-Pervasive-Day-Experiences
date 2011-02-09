require 'placemaker'

p = Placemaker::Client.new(:appid => "55Zy4lHV34EctmKfgSWYC3ugpfiYsuPbMdvvUFASt9Clg5pF6NEz4hz.y_4Ry1eCTVE-", :document_content => '', :document_type => 'text/plain')
  p.fetch!


if(p.documents[0].geographic_scope.respond_to?("centroid"))

    p p.documents[0].geographic_scope.centroid.lat
    p p.documents[0].geographic_scope.centroid.lng

end

#Base controller which inherited by every api controller
class Api::V1::TypesController < Api::V1::BaseController  
  before_action :authenticate_provider!, except: [:alltypes]
 
  def alltypes
    render json: Type.all
  end

  def index
    resp = []
    Type.all.each do |type|
      value = current_provider.setting.types.include?(type) ? true : false
      resp.push({id: type.id, name: type.name, comment: type.comment, value: value})
    end

    render json: {types: resp}
  end



  def update
    my_types = []
    count_types = Type.count
    i = 0

    while i < count_types
      if params[i.to_s] == "true"
        t = Type.find(i+1)
        my_types.push(t)
      end
      i += 1
    end

    current_provider.setting.update(types: my_types)
    render json: {message: 'Your job types have been updated!'}
    
  end
end



WebcamPadrino::App.controllers :webcam do

  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get '/example' do
  #   'Hello world!'
  # end

  get :index do
    render 'index'
  end

  get :video, :map => '/video' do

    @@camera ||= OpenCV::CvCapture.open(:v4l2)

    boundary = 'webcam'

    headers \
        "Cache-Control" => "no-cache, private",
        "Pragma"        => "no-cache",
        "Content-type"  => "multipart/x-mixed-replace; boundary=#{boundary}"

    stream(:keep_open) do |out|
      500.times do
        img = @@camera.query
        jpg = img.resize(OpenCV::CvSize.new(300,200)).encode_image('.jpg', OpenCV::CV_IMWRITE_JPEG_QUALITY => 30 )
        out << "Content-type: image/jpg\n\n"
        out << jpg.pack('C*')
        out << "\n\n--#{boundary}\n\n"
      end
    end


  end

end

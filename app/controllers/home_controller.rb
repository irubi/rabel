require "net/http"
require "uri"
class HomeController < ApplicationController  
	def index
		@nicepictures = Nicepicture.all
		@nodes = Node.all
	end

	def about
		
	end

	def image
		exposure_program_hash = {
			0 => 'Not defined',
			1 => 'Manual',
			2 => 'Normal program',
			3 => 'Aperture priority',
			4 => 'Shutter priority',
			5 => 'Creative program (biased toward depth of field)',
			6 => 'Action program (biased toward fast shutter speed)',
			7 => 'Portrait mode (for closeup photos with the background out of focus)',
			8 => 'Landscape mode (for landscape photos with the background in focus)'
		}

		begin
			exif = EXIFR::JPEG.new("#{Rails.root}/public#{params[:url]}")
			result = {:camera => exif.model, #相机型号
								:date_time => exif.date_time_original.strftime("%Y-%m-%d %H:%M"), #拍摄时间
								:exposure_time => exif.exposure_time.to_s, #曝光时间
								:f_number => exif.f_number.to_f, #光圈系数
								:focal_length => exif.focal_length.to_f, #焦距
								:iso_speed_ratings => exif.iso_speed_ratings.to_s, #ISO感光值
								:exposure_program => exposure_program_hash[exif.exposure_program] #曝光模式1,2,3
							 }
			begin
				lat = exif.gps.latitude
				lng = exif.gps.longitude
				baidu_ak = '307b12e0f59bc84a70b2273b9a8df7fd'
	      url = "http://api.map.baidu.com/geocoder/v2/?ak=#{baidu_ak}&location=#{lat},#{lng}&output=json&pois=0"
	      uri = URI.parse(URI.encode(url.strip))
	      address JSON.parse(Net::HTTP.get(uri))["result"]["formatted_address"]
	      result[:address] = address
			rescue
				result[:address] = '无信息'
			end				
			respond_to do |format|
				format.json {render :json => result.to_json}
			end
		rescue

		end
	end
end

# desc "Explaining what the task does"
namespace :app_migrations do

	task update_nutrients: :environment do
		Nutrient.friendly.find( 'calories' ).update( position: 10 )
		total_fat = Nutrient.friendly.find( 'total-fat' )
		total_fat.update( position: 20 )
		Nutrient.friendly.find( 'saturated-fat' ).update( position: 21, parent: total_fat )
		Nutrient.where( slug: 'trans-fat' ).update_all( position: 22, parent_id: total_fat.id )
		Nutrient.where( slug: 'polyunsaturated-fat' ).update_all( position: 23, parent_id: total_fat.id )
		Nutrient.where( slug: 'monounsaturated-fat' ).update_all( position: 24, parent_id: total_fat.id )
		Nutrient.friendly.find( 'cholesterol' ).update( position: 130 )
		Nutrient.friendly.find( 'sodium' ).update( position: 140 )
		total_carbs = Nutrient.friendly.find( 'total-carbohydrate' )
		total_carbs.update( position: 150 )
		Nutrient.where( slug: 'net-carbohydrates' ).update_all( position: 151, parent_id: total_carbs.id )
		Nutrient.where( slug: 'dietary-fiber' ).update_all( position: 152, parent_id: total_carbs.id )
		Nutrient.where( slug: 'total-sugars' ).update_all( position: 153, parent_id: total_carbs.id )
		Nutrient.friendly.find( 'protein' ).update( position: 260 )
	end

	task install_discussions: :environment do
		discussions = []
		discussions << Scuttlebutt::Discussion.new( title: 'Beginners and Community Support', description: "The place to get a jumpstart on keto, meet others starting out and get help from veterans." )
		discussions << Scuttlebutt::Discussion.new( title: 'Food!', description: "Yum!  Inspiration for breakfast, lunch and dinner." )
		discussions << Scuttlebutt::Discussion.new( title: 'Random Chat', description: "The place for posts that don't belong anytwhere else." )
		discussions << Scuttlebutt::Discussion.new( title: 'Awesome Finds', description: "New and amazing things in the keto universe." )
		discussions << Scuttlebutt::Discussion.new( title: 'Science', description: "Ketones, ketosis and glucose oh my." )
		discussions << Scuttlebutt::Discussion.new( title: 'Progress', description: "Share your success, and inspire others." )
		discussions << Scuttlebutt::Discussion.new( title: 'Community', description: "Chat, gab, connect with others in the keto community." )
		discussions << Scuttlebutt::Discussion.new( title: 'Excercise', description: "Excercise, it's good for you." )
		discussions << Scuttlebutt::Discussion.new( title: 'Resources', description: "The best the internet, the printed word, and video has to offer the Keto WOL." )

		discussions.each do |discussion|
			discussion.user = User.admin.first
			discussion.publish_at = Time.now
			discussion.status = 'active'
			discussion.save!
		end

	end

end

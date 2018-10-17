# desc "Explaining what the task does"
namespace :app_migrations do

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

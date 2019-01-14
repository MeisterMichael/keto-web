
$( document ).ready ->

	$('.fr-view a[href*="https://youtu.be/"]').each ->
		$this = $(this)
		parts = $this.attr('href').split(/[?#]/)[0].split('/')
		id = decodeURI( parts[parts.length-1] ).trim()
		embed = '<p><span class="embed-responsive embed-responsive-16by9"><iframe width="560" height="315" src="https://www.youtube.com/embed/'+id+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen class="embed-responsive-item"></iframe></span></p>'
		if $this.parent().is('p')
			$this.parent().before(embed)
		else
			$this.before(embed)

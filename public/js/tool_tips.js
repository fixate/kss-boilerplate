(function(){
	$('.js-tooltip').each( function() {
		$this = $(this);

		$this.qtip({
			show: {
				ready: $this.data('qtip-ready'),
				event: $this.data('qtip-show-event'),
			},
			hide: {
				leave: false,
				event: $this.data('qtip-hide-event'),
			},
			content: {
				text: $this.data('qtip-content'),
				title: $this.data('qtip-content'),
			},
			style: {
				classes: $this.data('qtip-class'),
				tip: {
					width: 16,
					height: 16
				}
			},
			position: {
				my: $this.data('qtip-my'),
				at: $this.data('qtip-at'),
			}
		});
	});
})();

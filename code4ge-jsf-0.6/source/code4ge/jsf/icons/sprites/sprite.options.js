sprite = {
	options: [
		{
			inputFiles: [
				'../browser_chrome.png',
				'../browser_firefox.png',
				'../browser_ie.png',
				'../browser_opera.png',
				'../browser_safari.png'
			],
			outputSprite: 'sprite_browsers.png',
			outputCss: 'sprite_browsers.css',
			resize: 48,
			direction: 'vertically',
			cssClassPrefix: 'icon-',
			cssClassPostfix: '',
			cssSpriteFile: 'sprite_browsers.png'
		},
		{
			inputFiles: [
				'../close.png'
			],
			outputSprite: 'sprite_navigation.png',
			outputCss: 'sprite_navigation.css',
			resize: 48,
			actionIcons: true,
			direction: 'vertically',
			cssClassPrefix: 'icon-',
			cssClassPostfix: '',
			cssSpriteFile: 'sprite_navigation.png'
		}
	]
};

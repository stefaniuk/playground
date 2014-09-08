sprite = {
	options: [
		{
			inputFiles: [ 'icons/browser_chrome.png', 'icons/browser_ie.png' ],
			outputSprite: 'sprite1a.png',
			outputCss: 'sprite1a.css',
			resize: 64,
			direction: 'vertically',
			cssClassPrefix: 'icon-',
			cssClassPostfix: '-64',
			cssSpriteFile: 'sprite1a.png'
		},
		{
			inputFiles: [ 'icons/browser_chrome.png', 'icons/browser_ie.png' ],
			outputSprite: 'sprite1b.png',
			outputCss: 'sprite1b.css',
			resize: 64,
			direction: 'horizontally',
			cssClassPrefix: 'icon-',
			cssClassPostfix: '-64',
			cssSpriteFile: 'sprite1b.png'
		},
		{
			inputDir: 'icons/',
			outputSprite: 'sprite2a.png',
			outputCss: 'sprite2a.css',
			resize: 64,
			actionIcons: true,
			direction: 'vertically',
			cssClassPrefix: 'icon-',
			cssClassPostfix: '',
			cssSpriteFile: 'sprite2a.png'
		},
		{
			inputDir: 'icons/',
			outputSprite: 'sprite2b.png',
			outputCss: 'sprite2b.css',
			resize: 64,
			actionIcons: true,
			direction: 'horizontally',
			cssClassPrefix: 'icon-',
			cssClassPostfix: '',
			cssSpriteFile: 'sprite2b.png'
		}
	]
};

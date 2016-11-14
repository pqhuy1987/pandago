//
//  Sky.m
//  panda-run
//
//  Created by Qi He on 12-6-26.
//  Copyright (c) 2012年 heyook. All rights reserved.
//

#import "Sky.h"
#import "Constants.h"

@interface Sky()
- (CCSprite*) generateSprite;
- (CCTexture2D*) generateTexture;
@end

@implementation Sky

@synthesize sprite  = _sprite;
@synthesize offsetX = _offsetX;
@synthesize scale   = _scale;

+ (id) skyWithTextureSize:(int)ts {
	return [[[self alloc] initWithTextureSize:ts] autorelease];
}

- (id) initWithTextureSize:(int)ts {
	
	if ((self = [super init])) {
		
		textureSize = ts;
    
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		screenW = screenSize.width;
		screenH = screenSize.height;
		
		self.sprite = [self generateSprite];
		[self addChild:_sprite];
		
	}
	return self;
}

- (void) dealloc {
	self.sprite = nil;
	[super dealloc];
}

- (CCSprite*) generateSprite {
	
	CCTexture2D *texture = [self generateTexture];
	
	float w = (float)screenW/(float)screenH*textureSize;
	float h = textureSize;
	CGRect rect = CGRectMake(0, 0, w, h);
	
	CCSprite *sprite = [CCSprite spriteWithTexture:texture rect:rect];
	ccTexParams tp = {GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT};
	[sprite.texture setTexParameters:&tp];
	sprite.anchorPoint = ccp(1.0f/8.0f, 0);
	sprite.position = ccp(screenW/8, 0);
	
	return sprite;
}

- (void) renderNoise{
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);	
	
	CCSprite *s = [CCSprite spriteWithFile:IMAGE_BG_SKY];
	[s setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
	s.position = ccp(textureSize/2, textureSize/2);
//  s.scale = _scale * CC_CONTENT_SCALE_FACTOR();//remove this if we have HD version of the image
  
//	s.scale = (float)textureSize/512.0f;
	glColor4f(1,1,1,1);
	[s visit];
}

- (CCTexture2D*) generateTexture {
  
	CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
	
  //sky color
	ccColor3B c = (ccColor3B){202,234,246};
	ccColor4F cf = ccc4FFromccc3B(c);
	
	[rt beginWithClear:cf.r g:cf.g b:cf.b a:cf.a];
	
//	// layer 1: gradient
//	
//	float gradientAlpha = 0.3f;
//	
//	glDisable(GL_TEXTURE_2D);
//	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//	
//	ccVertex2F vertices[4];
//	ccColor4F colors[4];
//	int nVertices = 0;
//	
//	vertices[nVertices] = (ccVertex2F){0, 0};
//	colors[nVertices++] = (ccColor4F){1, 1, 1, 0};
//	vertices[nVertices] = (ccVertex2F){textureSize, 0};
//	colors[nVertices++] = (ccColor4F){1, 1, 1, 0};
//	
//	vertices[nVertices] = (ccVertex2F){0, textureSize};
//	colors[nVertices++] = (ccColor4F){1, 1, 1, gradientAlpha};
//	vertices[nVertices] = (ccVertex2F){textureSize, textureSize};
//	colors[nVertices++] = (ccColor4F){1, 1, 1, gradientAlpha};
//  
//	// adjust vertices for retina
//	for (int i=0; i<nVertices; i++) {
//		vertices[i].x *= CC_CONTENT_SCALE_FACTOR();
//		vertices[i].y *= CC_CONTENT_SCALE_FACTOR();
//	}
//	
//	glVertexPointer(2, GL_FLOAT, 0, vertices);
//	glColorPointer(4, GL_FLOAT, 0, colors);
//	glBlendFunc(GL_SRC_ALPHA, GL_ONE);
//	glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
	
  [self renderNoise];
	
	[rt end];
	
	return rt.sprite.texture;
}

- (void) setOffsetX:(float)offsetX {
	if (_offsetX != offsetX) {
		_offsetX = offsetX;
		CGSize size = _sprite.textureRect.size;
		_sprite.textureRect = CGRectMake(_offsetX, 0, size.width, size.height);
	}
}

- (void) setScale:(float)scale {
	if (_scale != scale) {
		const float minScale = (float)screenH / (float)textureSize;
		if (scale < minScale) {
			_scale = minScale;
		} else {
			_scale = scale;
		}
		_sprite.scale = _scale;
	}
}


@end

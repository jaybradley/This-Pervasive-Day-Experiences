package identity;

import processing.core.*;

//A Cell object

class Cell {
	float x, y;
	float w, h;
	ThisPervasiveDayIdentity parent;

	Cell(ThisPervasiveDayIdentity parent, float x, float y, float w, float h) {
		this.parent = parent;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}

	//void oscillate() {
	//	angle += 0.05;
	//}

	void draw() {

		//parent.stroke(255, 10);
		parent.fill(50, parent.random(1, 10));
		//parent.rect(x, y, w * parent.random(1, 2), h);
		parent.ellipse(x, y, w * parent.random(0.5f, 5), h * parent.random(0.5f, 5));
	}
}

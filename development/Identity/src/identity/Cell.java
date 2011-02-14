package identity;

import processing.core.*;

//A Cell object

class Cell {
	float x, y;
	float w, h;
	float angle;
	Identity parent;

	Cell(Identity parent, float x, float y, float w, float h, float angle) {
		this.parent = parent;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.angle = angle;
	}

	//void oscillate() {
	//	angle += 0.05;
	//}

	void draw() {

		parent.stroke(255, 10);
		parent.fill(80 + 127 * PApplet.cos(angle), 10);
		parent.rect(x, y, w * parent.random(1, 2), h);
	}
}

import raylib;

import std.math: sqrt, sin, cos, PI;

immutable float scalingFactor = sqrt(2.0);

struct Point {
	int x = 0; 
	int y = 0;
	int length = 0;
	int defaultLength = 0;
	
	this(int x, int y, int length) {
		this.x = x;
		this.y = y;
		this.length = length;
		this.defaultLength = length;
	}
}

void dragonCurve(float x, float y, float length, float angle, int limit) {
	if(limit <= 0) {
		DrawLineEx(Vector2(x, y), Vector2(x+length*cos(angle), y+length*sin(angle)), 1, WHITE);
		return;
	}
	
	dragonCurve(x, y, length/scalingFactor, angle-PI/4, limit-1);
	dragonCurve(x+length*cos(angle), y+length*sin(angle), length/scalingFactor, angle+PI/4 + PI, limit-1);
}

void main() {
    immutable int screenWidth = 640;
    immutable int screenHeight = 640;

    // init
    InitWindow(screenWidth, screenHeight, "Dlang Dragon Curve");
    SetTargetFPS(60);
	
	Point point = Point(100, 100, 400);

    while (!WindowShouldClose()) {
        // process events
		if(IsKeyDown(KeyboardKey.KEY_UP)) {
			point.y++;
		} else if(IsKeyDown(KeyboardKey.KEY_DOWN)) {
			point.y--;
		} else if(IsKeyDown(KeyboardKey.KEY_LEFT)) {
			point.x++;
		} else if(IsKeyDown(KeyboardKey.KEY_RIGHT)) {
			point.x--;
		} else if(IsKeyDown(KeyboardKey.KEY_Z)) {
			point.length += 10;
		} else if(IsKeyDown(KeyboardKey.KEY_X)) {
			point.length -= 10;
		} else if(IsKeyPressed(KeyboardKey.KEY_C)) {
			point.length = point.defaultLength;
		}

        // update

        // render
        BeginDrawing();
        ClearBackground(BLACK);
		
		dragonCurve(point.x, point.y, point.length, 0, 15);

        EndDrawing();
    }
	
    // quit
    CloseWindow();
}


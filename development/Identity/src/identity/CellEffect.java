package identity;

public class CellEffect {

	Identity parent;
	
	private Cell[][] grid;

	private int cols = 10;
	private int rows = 10;

	public CellEffect(Identity parent) {

		this.parent = parent;
		grid = new Cell[cols][rows];
		for (int i = 0; i < cols; i++) {
			for (int j = 0; j < rows; j++) {
				//grid[i][j] = new Cell(parent, i * parent.random(10, 20), j * parent.random(10, 30), 90, 80, i + j);
				grid[i][j] = new Cell(parent, parent.random( -100f, parent.width), parent.random(-100f, parent.height), 90, 80, i + j);
			}
		}
	}

	public void draw() {
		
		for (int i = 0; i < cols; i++) {
			for (int j = 0; j < rows; j++) {
				//grid[i][j].oscillate();
				grid[i][j].draw();
			}
		}
	}

}

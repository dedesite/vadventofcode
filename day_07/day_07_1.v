import os

string ContainedColor {
	color_node ColorNode,
	bag_count int
}

struct ColorNode {
	color string,
	visited bool = false,
	contained_colors ContainedColor[]
}

fn generate_color_graph(color_rules string[]) ColorNode {
	for rule in color_rules {
		mut color = color_rules.split('contain')[0]
		color = color.split(" bags")[0]
		contained_colors = color_rules.split('contain')[1]
	}
}

fn count_bags_color_handle_color(color string) {

}

color_rules := os.read_lines('input') ?
const skillPairs = [
  [["Java", "#fff", "java.jpg"], ["Docker", "#57b6e6", "docker.png"]],
  [["Photoshop", "#4082c3", "photoshop.png"], ["Node", "#333", "node.svg"]],
  [["Webpack", "#2e3a41", "webpack.png"], ["Pinia", "#fff", "pinia.svg"]],
  [["Python", "#fff", "python.png"], ["Vite", "#937df7", "vite.svg"]],
  [["Flutter", "#4499e4", "flutter.png"], ["Vue", "#b8f0ae", "vue.png"]],
  [["React", "#222", "react"], ["CSS3", "#2c51db", "css3.png"]],
  [["JS", "#f7cb4f", "javascript.png"], ["HTML", "#e9572b", "html.png"]],
  [["Git", "#df5b40", "git.webp"], ["Apifox", "#e65164", "apifox.png"]],
] as const;

export function SkillRibbon() {
  return (
    <div id="skills-tags-group-all" aria-hidden="true">
      <div className="tags-group-wrapper">
        {[...skillPairs, ...skillPairs].map((pair, index) => (
          <div className="tags-group-icon-pair" key={index}>
            {pair.map(([label, color, asset]) => (
              <div className="tags-group-icon" style={{ background: color }} key={label}>
              {asset === "react" ? (
                <svg viewBox="-11.5 -10.23174 23 20.46348" role="img">
                  <circle cx="0" cy="0" r="2.05" fill="#61dafb" />
                  <g stroke="#61dafb" strokeWidth="1" fill="none">
                    <ellipse rx="11" ry="4.2" />
                    <ellipse rx="11" ry="4.2" transform="rotate(60)" />
                    <ellipse rx="11" ry="4.2" transform="rotate(120)" />
                  </g>
                </svg>
              ) : (
                <img src={`/theme/skills/${asset}`} title={label} alt="" />
              )}
              </div>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}


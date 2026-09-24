import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter } from "react-router-dom";
import App from "./app/App";
import "./styles/index.css";
import "./styles/navigation.css";
import "./views/home/home-parity.css";
import "./styles/post-card-parity.css";
import "./views/home/aside-parity.css";
import "./views/articles/article-parity.css";
import "./views/home/home-hero.css";
import "./views/taxonomy/category.css";
import "./styles/pagination.css";
import "./styles/loading.css";
ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>,
);

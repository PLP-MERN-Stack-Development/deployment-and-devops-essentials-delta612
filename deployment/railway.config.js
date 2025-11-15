// Railway Deployment Configuration
// Instructions: Push this configuration to your Railway project

import { defineConfig } from "railway";

export default defineConfig({
  services: [
    {
      name: "backend",
      docker: "Dockerfile",
      rootDirectory: "backend",
      port: 5000,
      environment: {
        NODE_ENV: "production",
      },
      envFile: ".env",
    },
    {
      name: "frontend",
      docker: "Dockerfile",
      rootDirectory: "frontend",
      port: 3000,
      environment: {
        REACT_APP_API_URL: "${{ services.backend.url }}/api",
      },
    },
  ],
  plugins: ["@railway/discordjs-template"],
});

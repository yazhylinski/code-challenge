
### How to

Install dependencies:
```
bundle
```

Add your `ANTHROPIC_CLOUDE_API_KEY` to `.env.local` file.

Run script (example):
```
./smashing.rb --month=mmyyyy --them=string
```

### What to do

Here are a couple of improvements I already see:

- Try to save and recognize in threads to speed it up.
- Handle rate limits.
- I tried 3-5 wallpaper pages, and they worked. However, I see that their CSS structure differs from page to page, so there might be potential issues. **However, we could implement strategy pattern for parsing different styles as i did for AI**

### Examples
```
./smashing.rb --month=022023 --them=flowers
```

![](https://github.com/user-attachments/assets/6475d6e6-6c0a-492d-a9b6-4ee9b9e52b80)

![](https://github.com/user-attachments/assets/203d15e5-6db0-4a94-8b69-14a25e0f7f72)

![](https://github.com/user-attachments/assets/a4083be5-eda2-4bef-a3a9-159d1fa9494e)
